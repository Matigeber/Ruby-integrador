require 'zip'
class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: %i[ show edit update destroy export ]

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
    compiled_file = Zip::OutputStream.write_buffer do |html_file|
      @book.notes.each do |note|
        html_file.put_next_entry("#{note.title}.html")
        html_file << note.transform_to_html
      end
    end
    compiled_file.rewind
    send_data compiled_file.sysread, filename: "#{@book.name}.zip", :type => 'application/zip'
    #redirect_to book_notes_path(book.id), notice: "All notes of the book was successfully export."
  end

  def export_all
    compiled_book = Zip::OutputStream.write_buffer do |zip_book|
      current_user.books.each do |book |
        compiled_note = Zip::OutputStream.write_buffer do |html_note|
          book.notes.each do |note|
            html_note.put_next_entry("#{note.title}.html")
            html_note << note.transform_to_html
          end
        end
        compiled_note.rewind
        if not book.notes.empty?
          zip_book.put_next_entry("#{book.name}.zip")
          zip_book << compiled_note.sysread
        end
      end
    end
    compiled_book.rewind
    send_data compiled_book.sysread, filename: "All_books.zip", :type => 'application/zip'
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
    end unless @book.is_global?
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    if @book.is_global?
      @book.notes.delete_all
      redirect_to books_url, notice: "Notes of global book was successfully deleted."
    else
      @book.destroy
      respond_to do |format|
        format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
        format.json { head :no_content }
      end
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
