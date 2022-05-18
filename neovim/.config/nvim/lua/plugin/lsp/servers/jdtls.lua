local utils = require("utils")

-- Patterns of root folder
local root_markers = {
  '.git',
  'mvnw',
  'gradlew',
  'Config', -- Amazon
}
local root_dir = require('jdtls.setup').find_root(root_markers) -- Project root directory

local jdtls_home = '$XDG_DATA_HOME/nvim/lsp_servers/jdtls'
local jdtls_workspace = utils.path.concat('$XDG_CACHE_HOME/jdtls-workspace', vim.fn.fnamemodify(root_dir, ":p:h:t"))

-- Create jdtls_workspace if it doesn't exist
utils.path.safe_path(jdtls_workspace)


-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
return {
  -- The command that starts the lanjuage server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', vim.fn.glob(utils.path.concat(jdtls_home, 'plugins/org.eclipse.equinox.launcher_*.jar')),
    '-configuration', vim.fn.glob(utils.path.concat(jdtls_home, '/config_' .. utils.get_os())),
    '-data', vim.fn.glob(jdtls_workspace),
  },

  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      signatureHelp = { enabled = true };

      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
      },

      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },


  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  -- init_options = {
  --   bundles = {}
  -- },
}
