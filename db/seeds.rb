# Categorias
first_category = Category.create!(name: 'Eletrônicos')
Category.create!(name: 'Cozinha')
Category.create!(name: 'Vestuário')
Category.create!(name: 'Livros')
Category.create!(name: 'Esportes')

# Produtos
first_product = Product.create!(
  name: 'Monitor LG',
  description: 'Monitor de 32 polegadas da marca LG...',
  weight: 1500,
  width: 100,
  height: 80,
  depth: 15,
  category: first_category,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/monitor-lg.webp').to_s, 'image/webp')
)
second_product = Product.create!(
  name: 'Smartphone Samsung',
  description: 'Smartphone Samsung Galaxy S21 com tela de 6.2 polegadas...',
  weight: 200,
  width: 7,
  height: 15,
  depth: 8,
  category: first_category,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/smart-sam.webp').to_s, 'image/webp')
)
third_product = Product.create!(
  name: 'Notebook Dell',
  description: 'Notebook Dell Inspiron 15 com processador Intel Core i5...',
  weight: 2000,
  width: 36,
  height: 2,
  depth: 24,
  category: first_category,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/note-dell.webp').to_s, 'image/webp')
)
fourth_product = Product.create!(
  name: 'Smartwatch Apple',
  description: 'Smartwatch Apple Watch Series 6 com caixa de 44mm...',
  weight: 47,
  width: 3,
  height: 4,
  depth: 1,
  category: first_category,
  photo: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/products/smart-watch.webp').to_s, 'image/webp')
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

# Usuários regulares
User.create!(
  email: 'felipe@gmail.com',
  cpf: '33665186005',
  password: '123123'
)

User.create!(
  email: 'maria@gmail.com',
  cpf: '39889813033',
  password: '123123'
)

# Admins
first_admin = User.create!(
  email: 'maria@leilaodogalpao.com.br',
  cpf: '03507869098',
  password: '123123'
)
second_admin = User.create!(
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
  approved_by_id: second_admin.id
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
  approved_by_id: second_admin.id
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
  approved_by_id: first_admin.id
)
third_lot.products << first_product
third_lot.products << third_product
third_lot.products << fourth_product
third_lot.approved!
