class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.all_ratings
    @movies = Movie.all
    
    @filter=params[:ratings]|| session[:ratings]|| {}  
    if @filter == {}
      @filter = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    @filter_key=@filter.keys
    @movies=Movie.where(rating: @filter_key)
    
    
    
    sort=params[:sort_critical]|| session[:sort]
    case sort
    when 'by_title'
      @movies=@movies.order(:title)
      @movie_title=''
      @movie_title='hilite'
    when 'by_date'
      @movies=@movies.order(:release_date)
      @release_date=''
      @release_date='hilite'
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
