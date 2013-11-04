namespace :users do
  desc 'Creates initial users'
  task :create_first_user => :environment do
    unless User.where(name: 'admin').first
      User.create(name:                  'admin',
                  email:                 'admin@gt2.ru',
                  password:              'foo1foo',
                  password_confirmation: 'foo1foo')
    end
  end
end