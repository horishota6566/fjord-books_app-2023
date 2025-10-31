# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @alice  = users(:alice)
    @bob    = users(:bob)
    @report = reports(:one)
  end

  test '#editable? returns true when user is the author' do
    assert @report.editable?(@alice)
  end

  test '#editable? returns false when user is not the author' do
    assert_not @report.editable?(@bob)
  end

  test '#created_on returns date part of created_at' do
    @report.update(created_at: Time.zone.local(2025, 10, 31, 12, 34, 56))
    assert_equal Date.new(2025, 10, 31), @report.created_on
  end

  test '#save_mentions builds mention relationships from URLs in the content' do
    report = Report.create!(
      title: 'Railsの学習',
      content: "次の日報が参考になった → http://localhost:3000/reports/#{@report.id}",
      user: @alice
    )

    assert_equal [@report.id], report.reload.mentioning_report_ids
  end
end
