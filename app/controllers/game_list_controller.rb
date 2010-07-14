class GameListController < ApplicationController

  caches_page :show

  def show
    logger.error 'game_list'
		if (params[:id] == "123")
			render :json => Game.hot.limit(20).map {|g| {:id => g.id, :name => g.name, :pinyin => g.pinyin}}.to_json
		else
			render :json => Game.find_by_first_letter(params[:id].to_i.chr).map {|g| {:id => g.id, :name => g.name, :pinyin => g.pinyin}}.to_json
		end
  end

end
