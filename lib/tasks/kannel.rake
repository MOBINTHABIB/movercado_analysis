namespace :kannel  do
  desc "simulates Kannels requests"
  task :simulate => :environment do
    t = TrocaAkiValidation.where(name: "Troca Aki Campaign").first

    u = User.create!
    u.roles.create(app_id: t.id, name: "vendor")
    u.phones.create(number: SecureRandom.hex)
    
    # Sending the request
    1000.times do
      c = Code.create(app_id: t.id, user_id: u.id)
      Sms.receive(u.phones.first.number, SecureRandom.hex, c.to_s)
    end
  end
end