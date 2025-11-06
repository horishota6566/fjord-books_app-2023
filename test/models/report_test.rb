# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @alice  = users(:alice)
    @bob    = users(:bob)
    @r1 = reports(:alice_report)
    @r2 = reports(:bob_report)
  end

  test '#editable? returns true when user is the author' do
    assert @r1.editable?(@alice)
  end

  test '#editable? returns false when user is not the author' do
    assert_not @r1.editable?(@bob)
  end

  test '#created_on returns date part of created_at' do
    @r1.update(created_at: Time.zone.local(2025, 10, 31, 12, 34, 56))
    assert_equal Date.new(2025, 10, 31), @r1.created_on
  end

  test '#save_mentions builds mention relationships from URLs in the content' do
    report = Report.create!(
      title: 'Railsの学習',
      content: "次の日報が参考になった → #{report_url(@r1.id)}",
      user: @alice
    )

    assert_equal [@r1.id], report.reload.mentioning_report_ids
  end

  test '#save_mentions rebuilds mention relationships when saving' do
    report = Report.create!(
      title: 'Railsの学習',
      content: "次の日報が参考になった → #{report_url(@r1.id)}",
      user: @alice
    )

    assert_changes -> { report.reload.mentioning_report_ids }, from: [@r1.id], to: [@r2.id] do
      report.update!(content: "次の日報が参考になった → #{report_url(@r2.id)}")
    end
  end

  test '#save_mentions removes duplicate IDs when extracting from content' do
    report = Report.create!(
      title: 'Railsの学習',
      content: "次の日報が参考になった → #{report_url(@r1.id)} #{report_url(@r1.id)}",
      user: @alice
    )

    assert_equal [@r1.id], report.reload.mentioning_report_ids
  end

  test '#save_mentions excludes the report itself from mention targets' do
    report = Report.create!(
      title: 'Railsの学習',
      content: '内容未定',
      user: @alice
    )

    report.update!(content: "次の日報が参考になった → #{report_url(report.id)}")
    assert_not_includes report.reload.mentioning_report_ids, report.id
  end

  private

  def report_url(id) = "http://localhost:3000/reports/#{id}"
end
