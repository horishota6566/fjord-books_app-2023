# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました'
  end

  test 'visiting the index' do
    report = reports(:one)
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
    assert_text report.title
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'Railsのテストについて学習'
    fill_in '内容', with: 'Railsのテストについて学習しました。'
    assert_difference('Report.count', 1) do
      click_button '登録する'
      assert_text '日報が作成されました。'
    end

    assert_text 'Railsのテストについて学習'
  end

  test 'should update report' do
    report = reports(:one)
    visit report_url(report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: 'ブラックボックステストについて学習'
    fill_in '内容', with: '同値分割と境界値分析の考え方を理解しました。'
    click_button '更新する'

    assert_text '日報が更新されました。'
    assert_text 'ブラックボックステストについて学習'
  end

  test 'should destroy report' do
    report = reports(:one)
    visit report_url(report)
    assert_difference('Report.count', -1) do
      click_button 'この日報を削除'
      assert_text '日報が削除されました。'
    end
  end
end
