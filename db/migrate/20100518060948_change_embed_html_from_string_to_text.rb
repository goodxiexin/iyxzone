class ChangeEmbedHtmlFromStringToText < ActiveRecord::Migration
	def self.change_embed_html(table, klass, from, to)
	begin
		remove_column table.to_sym, "embed_html_#{to}"
	rescue 
		puts "not exist embed_html_#{to}"
	end
		add_column table.to_sym, "embed_html_#{to}".to_sym, to.to_sym
		klass.reset_column_information
		exists= klass.find(:all)
		say "#{table}: from #{from} to #{to} "
		klass.update_all("embed_html_#{to}=CONCAT(embed_html,'></embed>')")		
		remove_column table.to_sym, :embed_html
		rename_column table.to_sym, "embed_html_#{to}", :embed_html
	end

  def self.up
		self.change_embed_html("videos", Video, "string", "text")
		self.change_embed_html("news",   News,  "string", "text")
  end

  def self.down
		self.change_embed_html("videos", Video, "text", "string")
		self.change_embed_html("news",   News,  "text", "string")
  end
end
