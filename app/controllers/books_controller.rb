class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    @books = current_user.books
  end

  # GET /books/1 or /books/1.json
  def show
  end


  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  def export
    book = Book.find(params[:id])
    book.export_notes
    redirect_to book_notes_path(book.id), notice: "All notes of the book was successfully export."
  end

  def export_all
    current_user.export_all_books
    redirect_to books_path, notice: "All notes of the all books was successfully export."
  end

  # POST /books or /books.json
  def create
    @book = Book.new(name: book_params[:name], user: current_user)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(name: book_params[:name], user: current_user)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = current_user.search_book(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:name)
    end
end
