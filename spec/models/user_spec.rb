require 'spec_helper'

describe User do
  before{ @user = User.new(name:'Michael Heartl', email:'mheartl@example.com', password:'123456', password_confirmation:'123456') }
  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }
  describe "when name is not present" do
  	before { @user.name=" " }
  	it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @user.email=" " }
  	it { should_not be_valid}
  end

  describe "when name is too long" do
  	before { @user.name = "a" * 51}
  	it {should_not be_valid}
  end

  describe "when email address format is invalid" do
  	addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
    addresses.each do |invalid_address|
    	before{ @user.email=invalid_address }
    	it { should_not be_valid }
    end
  end

  describe "when email address format is valid" do
    addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    addresses.each{|valid_address|
    	before{ @user.email=valid_address }
    	it { should be_valid }
    }
  end

  describe "when email address is already taken" do
  	before do
  		user_with_same_email = @user.dup
  		user_with_same_email.save
  	end
  	it { should_not be_valid }
  end

  describe "when password is not present" do
  	before{
  		@user.password = " "
  		@user.password_confirmation = " "
  	}
  	it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
  	before{ @user.password_confirmation="mismatch" }
  	it { should_not be_valid }
  end

  describe "check the return value of authenticate method" do
  	before { @user.save }
  	let(:found_user){ User.find_by(email: @user.email) }

  	describe "with valid password" do
  		it { should eq found_user.authenticate(@user.password) }
  	end

  	describe "with invalid password" do
  		let(:user_for_invalid_password){ found_user.authenticate('invalid')}
  		it { should_not eq user_for_invalid_password }

  	end

  end

end
