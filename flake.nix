{
  description = "WhisperWriter environment: Whisper + GUI dictation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Manually specify Python packages you need here, e.g.
        pythonPackages = with pkgs.python311Packages; [
          # Add the Python packages here you want, e.g.
          aiohttp
          aiosignal
          annotated-types
          anyio
          async-timeout
          attrs
          audioplayer
          av
          certifi
          cffi
          charset-normalizer
          colorama
          coloredlogs
          ctranslate2
          distro
          EasyProcess
          entrypoint2
          faster-whisper
          ffmpeg-python
          filelock
          flatbuffers
          frozenlist
          fsspec
          future
          h11
          httpcore
          httpx
          huggingface-hub
          humanfriendly
          idna
          Jinja2
          llvmlite
          MarkupSafe
          more-itertools
          MouseInfo
          mpmath
          mss
          multidict
          networkx
          numba
          numpy
          onnxruntime
          openai
          packaging
          Pillow
          protobuf
          pycparser
          pydantic
          pydantic_core
          PyGetWindow
          PyMsgBox
          pynput
          pyperclip
          PyQt5
          PyQt5-Qt5
          PyQt5-sip
          pyreadline3
          PyRect
          pyscreenshot
          PyScreeze
          python-dotenv
          pytweening
          PyYAML
          regex
          requests
          six
          sniffio
          sounddevice
          soundfile
          sympy
          tiktoken
          tokenizers
          tqdm
          typing_extensions
          urllib3
          webrtcvad-wheels
          yarl
          whisper
        ];

        pythonEnv = pkgs.python311.withPackages (ps: pythonPackages);
      in {
        packages = {
          python = pythonEnv;
        };

        devShell = pkgs.mkShell {
          buildInputs = [ pythonEnv ];
        };
      });
}
