namespace :users do
  desc 'Creates initial users'
  task :create_first_user => :environment do
    unless User.where(name: 'admin').first
      User.create(name:                  'admin',
                  email:                 'admin@gt2.ru',
                  password:              'gt2rulez',
                  password_confirmation: 'gt2rulez')
    end
  end
end