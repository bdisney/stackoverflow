shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user)     { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:model)   { create(described_class.to_s.underscore.to_sym) }

  describe '#vote_up' do
    context 'user votes up for the first time' do
      it 'increases rating by 1' do
        expect { model.vote_up(user) }.to change(model, :rating).by(1)
      end
    end

    context 'when user votes up again for the same object' do
      let!(:vote) { create(:vote, votable: model, user: user) }

      it 'cancel previous vote' do
        expect { model.vote_up(user) }.to change(model, :rating).by(-1)
      end
    end

    context 'when user change his vote from negative to positive' do
      let!(:vote) { create(:negative_vote, votable: model, user: user) }

      it 'increases rating by 2' do
        expect { model.vote_up(user) }.to change(model, :rating).by(2)
      end
    end
  end

  describe '#vote_down' do
    context 'user votes down for the first time' do
      it 'decreases rating by 1' do
        expect { model.vote_down(user) }.to change(model, :rating).by(-1)
      end
    end

    context 'when user votes down again for the same object' do
      let!(:vote) { create(:negative_vote, votable: model, user: user) }

      it 'cancel previous vote' do
        expect { model.vote_down(user) }.to change(model, :rating).by(1)
      end
    end

    context 'when user change his vote from  positive to negative' do
      let!(:vote) { create(:vote, votable: model, user: user) }

      it 'decreases rating by 2' do
        expect { model.vote_down(user) }.to change(model, :rating).by(-2)
      end
    end
  end
end