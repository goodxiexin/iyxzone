Factory.define :user do |u|
  u.password '111111'
  u.sequence(:login) {|n| "person-#{n}"}
  u.email {|u| "#{u.login}@gmail.com"}
end

Factory.define :friendship do |f|
  f.status 1
end

Factory.define :friend_request, :parent => 'friendship' do |f|
  f.status 0 
end

Factory.define :game do |g|
  g.sequence(:name) {|n| "game-#{n}"}
  g.description {|g| "description of #{g.name}"}
end

Factory.define :game_server do |s|
  s.sequence(:name) {|n| "server-#{n}"}
end

Factory.define :game_area do |a|
  a.sequence(:name) {|n| "area-#{n}"}
end

Factory.define :game_race do |r|
  r.sequence(:name) {|n| "race-#{n}"}
end

Factory.define :game_profession do |p|
  p.sequence(:name) {|n| "profession-#{n}"}
end

Factory.define :game_character do |c|
  c.sequence(:name) {|n| "character-#{n}"}
  c.level 100
end

Factory.define :blog do |b|
  b.sequence(:title) {|n| "blog-#{n}"}
  b.content {|b| "cotent of #{b.title}"}
  b.privilege 1
  b.draft false
end

Factory.define :draft, :parent => 'blog' do |d|
  d.privilege 1
  d.draft true
end

