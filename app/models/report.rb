# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :active_mentions, class_name:  'Mention',
                                  foreign_key: 'mentioning_id',
                                  dependent:   :destroy
  has_many :passive_mentions, class_name:  'Mention',
                                  foreign_key: 'mentioned_id',
                                  dependent:   :destroy
  has_many :mentioning_reports, through: :active_mentions, source: :mentioned
  has_many :mentioned_reports, through: :passive_mentions, source: :mentioning

  validates :title, presence: true
  validates :content, presence: true

  after_commit :rebuild_mentions!, on: %i[create update]

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private
  def extract_report_ids_from(text)
    ids = text.scan(%r{http://localhost:3000/reports/(\d+)})
    ids.flatten.map(&:to_i).uniq.without(id)
  end

  def rebuild_mentions!
    ids = extract_report_ids_from(content)
    active_mentions.delete_all
    mentioning_reports << Report.where(id: ids)
  end
end
