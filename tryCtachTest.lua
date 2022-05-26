#require "try-catch"

try {
   function()
      error('oops')
   end,

   catch {
      function(error)
         DebugPrint('caught error: ' .. error)
      end
   }
}