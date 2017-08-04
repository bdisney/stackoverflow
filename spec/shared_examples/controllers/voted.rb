shared_examples_for 'voted' do
  sign_in_user

  resource_name = described_class.controller_name.singularize.to_sym
  let(:resource)      { create(resource_name) }
  let(:user_resource) { create(resource_name, user: @user) }

  def send_request(action, member)
    process action, method: :patch, params: { id: member }, format: :js
  end

  describe 'PATCH#vote_up' do
    context 'when user votes for someones resource' do
      it 'assigns requested votable resource to @votable' do
        send_request(:vote_up, resource)
        expect(assigns(:votable)).to eq(resource)
      end

      it 'increases rating by 1' do
        expect { send_request(:vote_up, resource) }
          .to change(resource, :rating).by(1)
      end

      it 'responds with json' do
        send_request(:vote_up, resource)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'when user tries vote for his resource' do
      it 'assigns requested votable resource to @votable' do
        send_request(:vote_up, user_resource)
        expect(assigns(:votable)).to eq(user_resource)
      end

      it "doesn't save vote to db" do
        expect { send_request(:vote_up, user_resource) }
            .to_not change(Vote, :count)
      end

      it 'responds with status code 422' do
        send_request(:vote_up, user_resource)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH#vote_down' do
    context 'when user votes for someones resource' do
      it 'assigns requested votable resource to @votable' do
        send_request(:vote_down, resource)
        expect(assigns(:votable)).to eq(resource)
      end

      it 'decreases rating by 1' do
        expect { send_request(:vote_down, resource) }
            .to change(resource, :rating).by(-1)
      end

      it 'responds with json' do
        send_request(:vote_down, resource)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'when user tries vote for his resource' do
      it 'assigns requested votable resource to @votable' do
        send_request(:vote_down, user_resource)
        expect(assigns(:votable)).to eq(user_resource)
      end

      it "doesn't save vote to db" do
        expect { send_request(:vote_down, user_resource) }
            .to_not change(Vote, :count)
      end

      it 'responds with status code 422' do
        send_request(:vote_down, user_resource)
        expect(response.status).to eq(422)
      end
    end
  end
end