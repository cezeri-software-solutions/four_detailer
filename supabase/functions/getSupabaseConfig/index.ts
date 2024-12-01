//! supabase functions new getSupabaseConfig
//! supabase functions deploy getSupabaseConfig

import { corsHeaders } from "./../_shared/cors.ts";

Deno.serve((_) => {
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY");

  console.log("Supabase URL:", supabaseUrl);
  console.log("Supabase Anon Key:", supabaseAnonKey);

  const responsePayload = {
    SUPABASE_URL: supabaseUrl,
    SUPABASE_ANON_KEY: supabaseAnonKey,
  };

  return new Response(JSON.stringify(responsePayload), {
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
});
