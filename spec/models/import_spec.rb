require 'spec_helper'

describe Import do
  it 'has a valid factory' do
    build(:user).should be_valid
  end

  it 'belongs to user' do
    user = create(:user)
    import = build(:import, user: user)
    import.user.should == user
  end

  it 'requires a user' do
    import = build(:import, user_id: nil)
    import.should_not be_valid
    import.errors[:user_id].should == ["can't be blank"]
  end

  it 'validates its state' do
    import = build(:import, state: 'whatever')
    import.should_not be_valid
    import.errors[:state].should == ["is not included in the list"]

    build(:import, state: 'running').should be_valid
  end
end
