# == Schema Information
#
# Table name: lists
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

class List < ActiveRecord::Base
  attr_accessible :title, :description, :tag_list
  acts_as_taggable
  acts_as_commentable

  validates :title,   presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  belongs_to :user
  has_many :listings, dependent: :destroy
  has_many :courses,  through: :listings
  has_many :likes, dependent: :destroy, as: :likeable
  has_many :notifications, dependent: :destroy, as: :notifiable
    
  scope :non_empty, lambda{ all.select{ |list| list.courses.any? } }
  default_scope order: 'lists.created_at DESC'

  def add!(course, *arg)
    description = arg[0] if arg
    listings.create!(course_id: course.id, description: description)
  end

  def remove!(course)
    listings.find_by_course_id(course.id).destroy
  end

  def add_tags!(tag_list)
    self.tag_list = tag_list
    self.save
  end

  def self.has(course)
    lists = []
    listing = Listing.find_by_course_id(course.id)
    lists << listing.list if listing
    lists
  end

end