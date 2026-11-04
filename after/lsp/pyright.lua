-- Python type checking preferences.
-- Change typeCheckingMode to "strict" if desired for a project.
return {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
}
