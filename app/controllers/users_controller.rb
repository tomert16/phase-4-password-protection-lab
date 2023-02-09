class UsersController < ApplicationController
    wrap_parameters format: []
    before_action :authorized, only: [:show]


    ## SHOW method to show that the user is authenticated 
    def show 
        user = User.find(session[:user_id])
        render json: user
    end

    ## Create a new user, save the password as hashed password in the database and save the username in sessions hash
    def create
        new_user = User.create(user_params)
        if new_user.valid?
            session[:user_id] = new_user.id
            render json: new_user, status: :created
        else
            render json: { error: new_user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def authorized
        render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
    end
end
