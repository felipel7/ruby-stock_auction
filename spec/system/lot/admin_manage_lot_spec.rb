require "rails_helper"

describe "Admin acessa um lote" do
  it "e adiciona um produto" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
    lot = Lot.create!(
      batch_code: "EOR661430",
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: admin.id,
    )
    category = Category.create!(name: "Eletrônicos")
    product = Product.create!(
      name: "Caixa de som JBL",
      description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
      weight: 2393,
      width: 13,
      height: 28,
      depth: 13,
      category: category,
    )

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Gerenciar Lotes"
    end
    click_on "Gerenciar"
    click_on "Adicionar"

    expect(page).to have_content "O produto foi adicionado com sucesso."
    expect(page).to have_content "Dimensões: 13cm x 28cm x 13cm"
    expect(page).to have_content "Categoria: Eletrônicos"
    expect(page).to have_content "Peso: 2393g"
    expect(page).not_to have_button "Adicionar"
  end

  it "e remove um produto" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
    lot = Lot.create!(
      batch_code: "EOR661430",
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: admin.id,
    )
    category = Category.create!(name: "Eletrônicos")
    product = Product.create!(
      name: "Caixa de som JBL",
      description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
      weight: 2393,
      width: 13,
      height: 28,
      depth: 13,
      category: category,
    )
    lot.products << product

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Gerenciar Lotes"
    end
    click_on "Gerenciar"
    click_on "Remover"

    expect(page).to have_content "O produto foi removido com sucesso."
    expect(page).not_to have_content "Descrição: Caixa de som JBL Xtreme 2"
  end

  it "e não tem permissão para aprovar o lote que ele registrou" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
    lot = Lot.create!(
      batch_code: "EOR661430",
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: admin.id,
    )

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Gerenciar Lotes"
    end
    click_on "Gerenciar"
    click_on "Aprovar Lote"

    expect(page).to have_content "O administrador deve ser distinto daquele que registrou o lote"
    expect(lot.reload.approved_by).to be nil
  end

  it "e outro admin aprova o lote com sucesso" do
    first_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
    second_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "09468829081", password: "123123")
    lot = Lot.create!(
      batch_code: "EOR661430",
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: first_admin.id,
    )
    category = Category.create!(name: "Eletrônicos")
    product = Product.create!(
      name: "Caixa de som JBL",
      description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
      weight: 2393,
      width: 13,
      height: 28,
      depth: 13,
      category: category,
    )

    lot.products << product
    login_as(second_admin)
    visit root_path
    within "aside" do
      click_on "Gerenciar Lotes"
    end
    click_on "Gerenciar"
    click_on "Aprovar Lote"

    expect(page).to have_content "O lote foi aprovado com sucesso."
    expect(lot.reload.approved_by).to eq second_admin
  end

  it "e não consegue aprovar um lote que já foi aprovado" do
    first_admin = User.create!(email: "Felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
    second_admin = User.create!(email: "Maria@leilaodogalpao.com.br", cpf: "09468829081", password: "123123")
    lot = Lot.create!(
      batch_code: "EOR661430",
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: first_admin.id,
    )
    category = Category.create!(name: "Eletrônicos")
    product = Product.create!(
      name: "Caixa de som JBL",
      description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
      weight: 2393,
      width: 13,
      height: 28,
      depth: 13,
      category: category,
    )

    lot.products << product
    login_as(second_admin)
    visit root_path
    within "aside" do
      click_on "Gerenciar Lotes"
    end
    click_on "Gerenciar"
    click_on "Aprovar Lote"
    within "aside" do
      click_on "Gerenciar Lotes"
    end
    visit manage_admin_lot_path(lot.id)
    click_on "Aprovar Lote"

    expect(page).to have_content "O lote já foi aprovado"
    expect(page).to have_content "Criado por: Felipe"
    expect(page).to have_content "Aprovado por: Maria"
  end

  it "e não consegue aprovar um lote que não tem nenhum produto" do
    first_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
    second_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "09468829081", password: "123123")
    lot = Lot.create!(
      batch_code: "EOR661430",
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: first_admin.id,
    )

    login_as(second_admin)
    visit root_path
    within "aside" do
      click_on "Gerenciar Lotes"
    end
    click_on "Gerenciar"
    click_on "Aprovar Lote"

    expect(page).not_to have_content "O lote foi aprovado com sucesso."
    expect(page).to have_content "O lote não pode ser aprovado."
    expect(page).to have_content "Um produto deve ser incluído para que um lote possa ser aprovado"
  end

  context "encerrado" do
    it "e não consegue aprovar um lote sem lances" do
      first_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
      second_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "09468829081", password: "123123")
      lot = Lot.create!(
        batch_code: "EOR661430",
        start_date: 2.seconds.from_now,
        end_date: 2.hours.from_now,
        min_value: 1000,
        min_allowed_difference: 50,
        register_by_id: first_admin.id,
        approved_by_id: second_admin.id,
      )
      lot.update(status: :ended)
      lot.reload

      login_as(second_admin)
      visit root_path
      within "aside" do
        click_on "Gerenciar Lotes"
      end
      click_on "Ver"
      click_on "Validar Resultado"

      expect(page).to have_content "Não é possível validar o resultado de um lote sem lances."
    end

    it "e consegue aprovar um lote com sucesso" do
      first_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
      second_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "09468829081", password: "123123")
      user = User.create!(email: "joao@gmail.com.br", cpf: "77694319054", password: "123123")
      lot = Lot.create!(
        batch_code: "EOR661430",
        start_date: 1.minute.from_now,
        end_date: 2.hours.from_now,
        min_value: 1000,
        min_allowed_difference: 50,
        register_by_id: first_admin.id,
        approved_by_id: second_admin.id,
      )
      category = Category.create!(name: "Eletrônicos")
      product = Product.create!(
        name: "Caixa de som JBL",
        description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
        weight: 2393,
        width: 13,
        height: 28,
        depth: 13,
        category: category,
      )
      lot.products << product
      lot.update(start_date: 1.minute.ago)
      lot.update(status: :approved)
      Bid.create!(lot: lot, user: user, amount: 100)
      lot.update(status: :ended)

      login_as(second_admin)
      visit root_path
      within "aside" do
        click_on "Gerenciar Lotes"
      end
      click_on "Ver"
      click_on "Validar Resultado"

      expect(page).to have_content "O lote foi atualizado com sucesso."
    end

    it "e não consegue cancelar um lote que possui lances" do
      first_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
      second_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "09468829081", password: "123123")
      user = User.create!(email: "joao@gmail.com.br", cpf: "77694319054", password: "123123")
      lot = Lot.create!(
        batch_code: "EOR661430",
        start_date: 1.minute.from_now,
        end_date: 2.hours.from_now,
        min_value: 1000,
        min_allowed_difference: 50,
        register_by_id: first_admin.id,
        approved_by_id: second_admin.id,
      )
      category = Category.create!(name: "Eletrônicos")
      product = Product.create!(
        name: "Caixa de som JBL",
        description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
        weight: 2393,
        width: 13,
        height: 28,
        depth: 13,
        category: category,
      )
      lot.products << product
      lot.update(start_date: 1.minute.ago)
      lot.update(status: :approved)
      Bid.create!(lot: lot, user: user, amount: 100)
      lot.update(status: :ended)

      login_as(second_admin)
      visit root_path
      within "aside" do
        click_on "Gerenciar Lotes"
      end
      click_on "Ver"
      click_on "Cancelar Lote"

      expect(page).to have_content "O cancelamento só é permitido quando não existem lances associados."
    end

    it "e cancela um lote com sucesso" do
      first_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
      second_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "09468829081", password: "123123")
      user = User.create!(email: "joao@gmail.com.br", cpf: "77694319054", password: "123123")
      lot = Lot.create!(
        batch_code: "EOR661430",
        start_date: 1.minute.from_now,
        end_date: 2.hours.from_now,
        min_value: 1000,
        min_allowed_difference: 50,
        register_by_id: first_admin.id,
        approved_by_id: second_admin.id,
      )
      category = Category.create!(name: "Eletrônicos")
      product = Product.create!(
        name: "Caixa de som JBL",
        description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
        weight: 2393,
        width: 13,
        height: 28,
        depth: 13,
        category: category,
      )
      lot.products << product
      lot.update(start_date: 1.minute.ago)
      lot.update(status: :approved)
      lot.update(status: :ended)

      login_as(second_admin)
      visit root_path
      within "aside" do
        click_on "Gerenciar Lotes"
      end
      click_on "Ver"
      click_on "Cancelar Lote"

      expect(page).to have_content "O lote foi atualizado com sucesso."
    end
  end
end
