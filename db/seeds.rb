
# 🧹
Author.destroy_all
Book.destroy_all
BookInstance.destroy_all
User.destroy_all
Publisher.destroy_all

# create-funs
def create_publishers(n)
    n.times do
        pub = Publisher.create(
            name: [Faker::Name.last_name, Faker::Name.last_name].sample(rand(1..2))
                    .join([" & ", " und ", " "].sample) + [" Verlag", " Verlag", " Verlag", "-Gruppe", " Media"].sample,
            address: Faker::Address.full_address
        )
        pub.save
        puts "Created Publisher #{pub.name}"
    end
end
def create_users(n, admin = false)
    n.times do 
        currUser = User.create(
            family_name: Faker::Name.unique.last_name,
            given_name: Faker::Name.first_name,
            address: Faker::Address.full_address,
            email: admin ? "admin@rails.de" : Faker::Internet.unique.email,
            password: admin ? "passw0rd" : Faker::Internet.password(min_length: 8),
            admin: admin
        )
        if Faker::Boolean.boolean(true_ratio: 0.2)
            currUser.blocked = true
            currUser.remarks = ['brought damaged books', 'always brings books late'].sample
        end
    
        currUser.save
        puts "Created User #{currUser.family_name}"
        puts("##########\nAdmin Account is\nE-Mail:   #{currUser.email}\nPassword: #{currUser.password}") if admin
    end
end
def create_authors(n)
    n.times do
        currAuthor = Author.create(
            family_name: Faker::Name.unique.last_name, 
            given_name: Faker::Name.first_name, 
            affiliation: Faker::University.name
        )
    
        puts "Created Author #{currAuthor.family_name}"
    
        currAuthor.save
    end
end
def create_books(n)
    n.times do
        currBook = Book.create(
            title: Faker::Book.unique.title,
            authors: Author.all.sample(rand(1..3)),
            publisher: Publisher.all.sample,
            pub_year: Faker::Number.between(from: 1850, to: 2021),
            edition: Faker::Number.between(from: 1, to: 15),
            isbn: Faker::Number.number(digits: 13)
        )
        currBook.save

        puts "Created Book ##{currBook.id}"

        Faker::Number.between(from: 0, to: 3).times do
            currBookInst = currBook.book_instances.create(
                reserved_by_id: [true, false, false].sample ? User.all.sample.id : nil,
                purchased_at: Faker::Number.between(from: 1, to: (2021-currBook.pub_year) * 365).days.ago,
                shelfmark: (Faker::NatoPhoneticAlphabet.code_word[0].capitalize + Faker::Number.number(digits: 2).to_s)
            )
            if [true, false, false].sample
                lendUser = User.all.sample
                currBookInst.lended_by_id = lendUser.id
                currBookInst.save # fix for controller explicitly set due_dates
                if lendUser.blocked
                    currBookInst.due_at = Date.tomorrow + rand(-10..-5).days
                else
                    currBookInst.due_at = Date.tomorrow + rand(-2..30).days
                end
            end
            currBookInst.save
        end

        puts "Created #{currBook.book_instances.count} Bookinstances"
    end
end

# 🆕
size = 2

create_publishers(5  *size)
create_users(20 *size)
create_authors(10 *size)
create_books(50 *size)
## no associated books for following:
create_publishers(size)
create_authors(size)
## create admin
create_users(1, true)
