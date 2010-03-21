d = Dir.new('.')
count = 0
l1=[]
l2=[]
ehash = {}
d.each do |f|
	if i = f.index('.gif')
		token= f[0...i]
		ehash["[#{token}]"] = token
	end
end
puts ehash.inspect
ehash.each do |k,v|
	l1 << k
	l2 << v
end
puts l1.inspect
puts l2.inspect

def output(x)
	x.each do |item|
	print "'#{item}', "
	end
end

output(l1)
