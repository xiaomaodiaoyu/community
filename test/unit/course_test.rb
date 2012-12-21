# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  provider_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  code          :string(255)
#  image_link    :string(255)
#  description   :text
#  subtitle      :string(255)
#  instructor    :string(255)
#  prerequisites :text
#  url           :string(255)
#  start_date    :datetime
#  final_date    :datetime
#  duration      :integer
#

require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
