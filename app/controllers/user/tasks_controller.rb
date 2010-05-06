require 'yaml'
class User::TasksController < ApplicationController
	#/tasks/index.html
	def index
		@alltasks 		= Task.find(:all)
		@visibleTask 	= @alltasks.select 	{|t| t.is_visible?}
		@regularTask 	= @alltasks.select	{|t| t.is_regular?}
		@everydayTask = @alltasks.select 	{|t| t.is_everyday?}
	end
end


