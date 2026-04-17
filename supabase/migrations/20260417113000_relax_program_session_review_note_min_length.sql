alter table public.program_session_reviews
  drop constraint if exists program_session_reviews_completion_note_length_check;

alter table public.program_session_reviews
  add constraint program_session_reviews_completion_note_length_check
    check (char_length(trim(completion_note)) between 1 and 300);
