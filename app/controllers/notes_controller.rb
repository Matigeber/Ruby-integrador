class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    @notes = Book.find(params[:book_id]).notes
  end

  # GET book/id/notes/1 or /notes/1.json
  def show
  end

  def export
    note = Note.find(params[:id])
    note.export
    redirect_to book_notes_path(note.book_id), notice: "Note was successfully export."
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(title: note_params[:title], content: note_params[:content], book: current_user.search_book(params[:book_id]))

    respond_to do |format|
      if @note.save
        format.html { redirect_to book_notes_path(@note.book_id), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(title: note_params[:title], content: note_params[:content])
        format.html { redirect_to book_notes_path(@note.book_id), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to book_notes_path(@note.book_id), notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      #@note = Note.find(params[:id])
      @note =current_user.search_book(params[:book_id]).find_note(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:book_id, :title, :content)
    end
end
