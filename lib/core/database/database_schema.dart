abstract class DatabaseSchema {
  static const name = 'quiz_app.db';
  static const version = 1;

  static const createStatements = <String>[
    '''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      image_url TEXT,
      color TEXT
    )
    ''',
    '''
    CREATE TABLE questions (
      id INTEGER PRIMARY KEY,
      category_id INTEGER NOT NULL,
      question_text TEXT NOT NULL,
      type TEXT NOT NULL,
      explanation TEXT,
      image_url TEXT,
      FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
    )
    ''',
    'CREATE INDEX idx_questions_category_id ON questions (category_id)',
    '''
    CREATE TABLE options (
      id INTEGER PRIMARY KEY,
      question_id INTEGER NOT NULL,
      option_text TEXT NOT NULL,
      is_correct INTEGER NOT NULL,
      FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE
    )
    ''',
    'CREATE INDEX idx_options_question_id ON options (question_id)',
    '''
    CREATE TABLE meta (
      key TEXT PRIMARY KEY,
      value TEXT
    )
    ''',
  ];
}