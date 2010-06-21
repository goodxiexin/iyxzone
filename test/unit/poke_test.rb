require 'test_helper'

class PokeTest < ActiveSupport::TestCase

  def setup
    @poke = PokeFactory.create
    @user = UserFactory.create
    @friend = UserFactory.create
    @stranger = UserFactory.create
    FriendFactory.create @user, @friend
    [@user, @friend].each {|f| f.reload}
  end

  test "poke delivery counter" do
    assert_no_difference "PokeDelivery.count" do
      PokeDelivery.create :poke_id => 'invalid', :sender_id => @friend.id, :recipient_id => @user.id
    end

    assert_no_difference "PokeDelivery.count" do
      PokeDelivery.create :poke_id => @poke.id, :sender_id => nil, :recipient_id => @user.id
    end

    assert_no_difference "PokeDelivery.count" do
      PokeDelivery.create :poke_id => @poke.id, :sender_id => @friend.id, :recipient_id => nil
    end

    assert_difference "PokeDelivery.count" do
      @delivery = PokeDelivery.create :poke_id => @poke.id, :sender_id => @friend.id, :recipient_id => @user.id
    end
    @user.reload
    assert @user.poke_deliveries_count, 1

    @delivery.destroy
    @user.reload
    assert @user.poke_deliveries_count, 0
  end

  test "sent mail" do
    @user.mail_setting.update_attributes(:poke_me => 1)
    assert_difference "Email.count" do
      PokeDelivery.create :poke_id => @poke.id, :sender_id => @friend.id, :recipient_id => @user.id
    end
  end

  test "delete all" do
    assert_difference "PokeDelivery.count", 2 do
      PokeDelivery.create :poke_id => @poke.id, :sender_id => @user.id, :recipient_id => @friend.id
      PokeDelivery.create :poke_id => @poke.id, :sender_id => @user.id, :recipient_id => @friend.id
    end

    assert_difference "PokeDelivery.count", -2 do
      PokeDelivery.delete_all_for @friend
    end
    @friend.reload
    # TODO: 咋回事
    assert_equal @friend.poke_deliveries_count, 0
  end

end
