Factory.define :user do |u|
  u.password '111111'
  u.sequence(:login) {|n| "person-#{n}"}
  u.email {|u| "#{u.login}@gmail.com"}
end

Factory.define :game_character do |character|
  character.sequence(:name) {|n| "character-#{n}"}
  character.level 2
end

Factory.define :game do |g|
  g.sequence(:name) {|n| "game-#{n}"}
  g.description     {|g| "description of #{g.name}"}
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
  b.sequence(:title) {|n| "title-#{n}"}
  b.sequence(:content) {|n| "content-#{n}"}
end

Factory.define :video do |v|
  v.sequence(:title) {|n| "title-#{n}"}
  v.sequence(:description) {|n| "description-#{n}"}
end

Factory.define :guild do |g|
  g.sequence(:name) {|n| "name-#{n}"}
  g.sequence(:description) {|n| "description-#{n}"}
end
