require 'test_helper'

class ReportTest < ActiveSupport::TestCase

  def setup
    @user = UserFactory.create
    @sensitive = '政府'
  end

  test "send report" do
    # 已经审核通过的能举报
    @blog = BlogFactory.create
    assert @blog.accepted?

    assert_difference "Report.count" do
      @blog.reports.create :poster_id => @user.id, :category => Report::CATEGORY[0]
    end
    @blog.reload
    assert @blog.unverified?

    # 还未审核的能举报
    @blog = BlogFactory.create :title => @sensitive
    assert @blog.unverified?

    assert_difference "Report.count" do
      @blog.reports.create :poster_id => @user.id, :category => Report::CATEGORY[0]
    end
    @blog.reload
    assert @blog.unverified?
   
    # 审核不通过的不能举报
    @blog = BlogFactory.create
    @blog.unverify
    assert @blog.rejected?

    assert_no_difference "Report.count" do
      @blog.reports.create :poster_id => @user.id, :category => Report::CATEGORY[0]
    end
  end


end
