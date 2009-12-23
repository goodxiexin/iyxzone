module User::PollsHelper

  def max_multiple_select_tag
    options = [['单选', 1]]
    20.times do |i|
      options << ["最多#{i}项", i]
    end
    select_tag 'poll[max_multiple]', options_for_select(options, 1)
  end

  def generate_result_bar(answer_votes, poll_votes)
    "<script language='javascript'>Iyxzone.Poll.drawPercentBar(200, #{100*answer_votes/poll_votes}, '#{cycle '#f7ca9b','#bde877', '#6c81b6', '#a5cbd6', '#d843b3', '#e2fea7', '#ee335f', '#ffc535', '#d8e929' }', '#efefef'); </script>"
  end

  def votable? poll, user
    user == poll.poster || poll.privilege == 1 || (poll.privilege == 2 and poll.poster.friends.include? user)
  end

end
