ActiveRecord::Schema.define(:version => 0) do
	create_table :tasks do |t|
		t.text	:prerequisite	#Array
		t.text	:requirement	#Array
		t.text	:reward				#Array
		t.text	:description	#Array
		t.integer	:catagory		#everyday, single 
		t.datetime	:starts_at
		t.datetime	:expires_at
	end
end
