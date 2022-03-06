# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Marks API', type: :request do
  before do
    @user = FactoryBot.create(:user)

    @api_token = ENV['STAMPON_API_TOKEN']
    @invalid_api_token = 'acCeSS_10KEn-uNS10pa61E_tuKE.3Zu'

    @discord_params = { discord: { channel_id: Faker::Number.number(digits: 18),
                                   content_id: Faker::Number.number(digits: 18),
                                   user_id: @user.discord_id,
                                   user_name: @user.name,
                                   user_discriminator: @user.discriminator,
                                   user_display_name: @user.display_name,
                                   user_avatar: @user.avatar,
                                   author_id: Faker::Number.number(digits: 18),
                                   author_name: 'author',
                                   author_discriminator: Faker::Number.number(digits: 4),
                                   author_display_name: 'author_nickname',
                                   author_avatar: Faker::Number.hexadecimal(digits: 32),
                                   content: 'これはすごい有益な情報🐣を含んだ発言です。',
                                   wrote_at: Time.current.strftime('%s%L') } }
  end

  describe 'ブックマーク一覧を取得する' do
    context '有効なトークンを渡した時' do
      it 'ブックマーク一覧を取得できないこと' do
        get api_marks_path, params: nil, headers: { 'Authorization' => "Bearer #{@api_token}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'ログインしている時' do
      it 'ブックマーク一覧を取得できること' do
        FactoryBot.create(:mark0, user: @user)
        FactoryBot.create(:mark1, user: @user)

        sign_in_as(@user) { get root_path }

        get api_marks_path, params: nil, headers: nil
        expect(response).to have_http_status(:success)

        json = JSON.parse(response.body)

        expect(json["user"]["id"].to_i).to eq @user.id
        expect(json["marks"][0]["title"]).to eq "title_1"
        expect(json["marks"][0]["note"]).to eq "note_1"
        expect(json["marks"][1]["title"]).to eq "title_0"
        expect(json["marks"][1]["note"]).to eq "note_0"
      end
    end

    context 'ログインしていない時' do
      it 'ブックマーク一覧を取得できないこと' do
        get api_marks_path, params: nil, headers: nil
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'ブックマーク詳細を取得する' do
    context '有効なトークンを渡した時' do
      it 'ブックマーク詳細を取得できないこと' do
        FactoryBot.create(:mark0, user: @user)

        get edit_api_mark_path(@user.marks.first), params: nil, headers: { 'Authorization' => "Bearer #{@api_token}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'ログインしている時' do
      it 'ブックマーク詳細を取得できること' do
        FactoryBot.create(:mark0, user: @user)

        sign_in_as(@user) { get root_path }

        get edit_api_mark_path(@user.marks.first), params: nil, headers: nil
        expect(response).to have_http_status(:success)

        json = JSON.parse(response.body)

        expect(json["user"]["id"].to_i).to eq @user.id
        expect(json["mark"]["title"]).to eq "title_0"
        expect(json["mark"]["note"]).to eq "note_0"
      end
    end

    context 'ログインしていない時' do
      it 'ブックマーク詳細を取得できないこと' do
        FactoryBot.create(:mark0, user: @user)

        get edit_api_mark_path(@user.marks.first), params: nil, headers: nil
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'ブックマークを追加する' do
    context '有効なトークンを渡した時' do
      it 'ブックマークを追加できること' do
        expect do
          post api_marks_path, params: @discord_params, headers: { 'Authorization' => "Bearer #{@api_token}" }
        end.to change(Mark, :count).by(+1)
        expect(response).to have_http_status(:success)

        expect(User.find_by(discord_id: @discord_params[:discord][:author_id])).to_not be_nil
      end
    end

    context '無効なトークンを渡した時' do
      it 'ブックマークを追加できないこと' do
        post api_marks_path, params: @discord_params, headers: { 'Authorization' => "Bearer #{@invalid_api_token}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'ログインしている時' do
      it 'ブックマークを追加できないこと' do
        FactoryBot.create(:mark0, user: @user)

        sign_in_as(@user) { get root_path }

        post api_marks_path, params: @discord_params, headers: nil
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'ブックマークを編集する' do
    context '有効なトークンを渡した時' do
      it 'ブックマークを編集できないこと' do
        FactoryBot.create(:mark0, user: @user)

        patch api_mark_path(@user.marks.first), params: { title: 'updated_title', note: 'updated_note' },
                                                headers: { 'Authorization' => "Bearer #{@api_token}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'ログインしている時' do
      it 'ブックマークを編集できること' do
        FactoryBot.create(:mark0, user: @user)

        sign_in_as(@user) { get root_path }

        mark = @user.marks.first

        patch api_mark_path(mark), params: { title: 'updated_title', note: 'updated_note' }, headers: nil
        expect(response).to have_http_status(:success)

        expect(Mark.find(mark.id).title).to eq 'updated_title'
        expect(Mark.find(mark.id).note).to eq 'updated_note'
      end
    end

    context 'ログインしていない時' do
      it 'ブックマークを編集できないこと' do
        FactoryBot.create(:mark0, user: @user)

        patch api_mark_path(@user.marks.first), params: { title: 'updated_title', note: 'updated_note' }, headers: nil
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'ブックマークを削除する' do
    context '有効なトークンを渡した場合' do
      it 'ブックマークを削除できないこと' do
        FactoryBot.create(:mark0, user: @user)

        delete api_mark_path(@user.marks.first), params: nil, headers: { 'Authorization' => "Bearer #{@api_token}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'ログインしている時' do
      it 'ブックマークを削除できること' do
        FactoryBot.create(:mark0, user: @user)

        sign_in_as(@user) { get root_path }

        mark = @user.marks.first

        expect do
          delete api_mark_path(mark), params: nil, headers: nil
        end.to change(Mark, :count).by(-1)
        expect(response).to have_http_status(:success)

        @user.reload
        expect(Mark.find_by(id: mark)).to be_nil
      end
    end

    context 'ログインしていない時' do
      it 'ブックマークを削除できないこと' do
        FactoryBot.create(:mark0, user: @user)

        delete api_mark_path(@user.marks.first), params: nil, headers: nil
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
