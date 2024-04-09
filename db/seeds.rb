# Categorias
first_category = Category.create!(name: 'Eletrônicos')
Category.create!(name: 'Cozinha')
Category.create!(name: 'Vestuário')
fourth_category = Category.create!(name: 'Livros')
fifth_category = Category.create!(name: 'Esportes')

# Produtos
first_product = Product.create!(
  name: 'PlayStation 5',
  description: 'PlayStation 5 console da Sony...',
  weight: 4500,
  width: 40,
  height: 30,
  depth: 10,
  category: first_category,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/ps5.png').to_s, 'image/png')
)
second_product = Product.create!(
  name: 'Smartphone Samsung',
  description: 'Smartphone Samsung Galaxy S21 com tela de 6.2 polegadas...',
  weight: 200,
  width: 7,
  height: 15,
  depth: 8,
  category: first_category,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/smartphones.png').to_s, 'image/png')
)
third_product = Product.create!(
  name: 'Coleção Senhor dos Anéis',
  description: 'Trilogia épica de J.R.R. Tolkien...',
  weight: 3000,
  width: 20,
  height: 25,
  depth: 10,
  category: fourth_category,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/book-lor.png').to_s, 'image/png')
)
fourth_product = Product.create!(
  name: 'Livro Python',
  description: 'Livro sobre a linguagem python...',
  weight: 600,
  width: 15,
  height: 20,
  depth: 2,
  category: fourth_category,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/book-python.png').to_s, 'image/png')
)
fifth_product = Product.create!(
  name: 'Câmera Sony',
  description: 'Câmera Sony Alpha a7 III com sensor full-frame de 24.2 MP...',
  weight: 650,
  width: 13,
  height: 11,
  depth: 7,
  category: first_category,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/sony-cam.webp').to_s, 'image/webp')
)
sixth_product = Product.create!(
  name: 'Xbox Series X',
  description: 'Xbox Series X console da Microsoft...',
  weight: 5000,
  width: 30,
  height: 15,
  depth: 10,
  category: first_category,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/xbox.png').to_s, 'image/png')
)
seventh_product = Product.create!(
  name: 'Bicicleta',
  description: 'Mountain bike...',
  weight: 12000,
  width: 70,
  height: 110,
  depth: 20,
  category: fifth_category,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/bike.webp').to_s, 'image/webp')
)

# Usuários regulares
User.create!(
  first_name: 'felipe',
  last_name: 'silva',
  email: 'felipe@gmail.com',
  cpf: '33665186005',
  password: '123123'
)

User.create!(
  first_name: 'maria',
  last_name: 'silva',
  email: 'maria@gmail.com',
  cpf: '39889813033',
  password: '123123'
)

# Admins
first_admin = User.create!(
  first_name: 'maria',
  last_name: 'silva',
  email: 'maria@leilaodogalpao.com.br',
  cpf: '03507869098',
  password: '123123'
)
second_admin = User.create!(
  first_name: 'fernando',
  last_name: 'silva',
  email: 'fernando@leilaodogalpao.com.br',
  cpf: '64063418057',
  password: '123123'
)

# Lotes
first_lot = Lot.create!(
  batch_code: 'ELE661430',
  start_date: 1.second.from_now,
  end_date: 1.hour.from_now,
  min_value: 2500,
  min_allowed_difference: 35,
  register_by_id: first_admin.id,
  approved_by_id: second_admin.id,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/smartphones-2.png').to_s, 'image/png')
)
first_lot.products << second_product
first_lot.approved!

second_lot = Lot.create!(
  batch_code: 'FTH123456',
  start_date: 3.minutes.from_now,
  end_date: 11.hours.from_now,
  min_value: 1500,
  min_allowed_difference: 25,
  register_by_id: first_admin.id,
  approved_by_id: second_admin.id,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/cameras.png').to_s, 'image/png')
)
second_lot.products << fifth_product
second_lot.approved!

Lot.create!(
  batch_code: 'LMP654321',
  start_date: 1.day.from_now,
  end_date: 2.days.from_now,
  min_value: 500,
  min_allowed_difference: 5,
  register_by_id: first_admin.id
)

third_lot = Lot.create!(
  batch_code: 'UIO234567',
  start_date: 1.second.from_now,
  end_date: 8.hours.from_now,
  min_value: 1200,
  min_allowed_difference: 20,
  register_by_id: second_admin.id,
  approved_by_id: first_admin.id,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/books.png').to_s, 'image/png')
)
third_lot.products << third_product
third_lot.products << fourth_product
third_lot.approved!

fourth_lot = Lot.create!(
  batch_code: 'FAE172457',
  start_date: 2.hours.from_now,
  end_date: 12.hours.from_now,
  min_value: 2900,
  min_allowed_difference: 40,
  register_by_id: second_admin.id,
  approved_by_id: first_admin.id,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/xbox.png').to_s, 'image/png')
)
fourth_lot.products << first_product
fourth_lot.products << sixth_product
fourth_lot.approved!
