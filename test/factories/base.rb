Factory.define :user do |u|
  u.password '111111'
  u.password_confirmation '111111'
  u.sequence(:login) {|n| "person-#{n}"}
  u.email {|u| "#{u.login}@gmail.com"}
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
  c.level 1
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

Factory.define :topic do |t|
  t.sequence(:subject) {|n| "subject-#{n}"}
  t.sequence(:content) {|n| "content-#{n}"}
end

Factory.define :post do |p|
  p.sequence(:content) {|n| "content-#{n}"}
end

Factory.define :skin do |s|
  s.sequence(:name) {|n| "skin-#{n}"}
  s.sequence(:css) {|n| "css-#{n}"}
  s.sequence(:thumbnail) {|n| "thumbnail-#{n}"}
end

Factory.define :guestbook do |g|
  g.sequence(:description) {|n| "guestbook-#{n}"}
  g.priority Guestbook::Urgent
  g.catagory '日志'
end

Factory.define :application do |a|
  a.sequence(:name) {|n| "application-#{n}"}
  a.sequence(:about) {|n| "about application-#{n}"}
end

Factory.define :poke do |p|
  p.sequence(:name) {|n| "poke-#{n}"}
  p.span_class 'i-f i-f-hug'
  p.content_html '<div></div>'
end

Factory.define :personal_album do |a|
  a.sequence(:title) {|n| "title-#{n}"}
  a.sequence(:description) {|n| "description-#{n}"}
  a.privilege PrivilegedResource::PUBLIC
end

Factory.define :photo do |p|
  p.sequence(:notation) {|n| "notation-#{n}"}
end

Factory.define :photo_tag do |t|
  t.x 0
  t.y 0
  t.width 100
  t.height 100
  t.content 'photo tag content'
end
