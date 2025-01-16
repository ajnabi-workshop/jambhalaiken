# run Aiken tests, build, and write validator(s)
@aiken VALIDATOR='' *BUILD_FLAGS='':
  @cd jambhalaiken && \
  aiken check && \
  aiken build {{ BUILD_FLAGS }} && \
  if [ -n "{{ VALIDATOR }}" ]; then \
    python write.py -v {{ VALIDATOR }}; \
  else \
    python write.py; \
  fi

# run cpd
@dojo:
  cd
  deno run './cpd/app.ts'
  
# codium editor
@code DIRECTORY='.':
  if [ "{{ DIRECTORY }}" = "." ] || [ -d "{{ DIRECTORY }}" ]; then \
    if [ "${VIM_MODE}" = 'true' ]; then \
      codium {{ DIRECTORY }}; \
    else codium {{ DIRECTORY }} --disable-extension asvetliakov.vscode-neovim; \
    fi \
  else echo "Invalid directory: {{ DIRECTORY }}"; \
  fi