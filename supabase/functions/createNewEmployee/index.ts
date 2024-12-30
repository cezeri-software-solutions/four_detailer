//! supabase functions new createNewEmployee
//! supabase functions deploy createNewEmployee

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";
import { corsHeaders } from "../_shared/cors.ts";

Deno.serve(async (req) => {
    // CORS-Präflight-Anfrage behandeln
    if (req.method === "OPTIONS") {
        return new Response("ok", { headers: corsHeaders });
    }

    try {
        const supabaseClient = createClient(
            Deno.env.get("SUPABASE_URL") ?? "",
            Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
        );

        // Request-Body parsen
        const { email, password, conditionerData } = await req.json();

        // Neuen Benutzer registrieren
        const { data: authData, error: authError } = await supabaseClient.auth
            .admin.createUser({
                email,
                password,
                email_confirm: true,
            });

        if (authError) {
            throw authError;
        }

        // Log der Daten
        console.log('Auth User ID:', authData.user.id);
        console.log('Conditioner Data:', JSON.stringify(conditionerData, null, 2));

        // RPC-Funktion aufrufen mit der UUID des neuen Benutzers
        const { data: conditionerResult, error: conditionerError } =
            await supabaseClient
                .rpc("create_conditioner", {
                    conditioner_json: conditionerData,
                    p_id: authData.user.id,
                });

        if (conditionerError) {
            console.error('RPC Error:', conditionerError);
            throw conditionerError;
        }

        return new Response(
            JSON.stringify({
                user: authData.user,
                conditioner: conditionerResult.conditioner,
            }),
            {
                headers: { ...corsHeaders, "Content-Type": "application/json" },
                status: 200,
            },
        );
    } catch (error) {
        const errorMessage = error instanceof Error
            ? error.message
            : "Ein unbekannter Fehler ist aufgetreten";
        return new Response(
            JSON.stringify({ error: errorMessage }),
            {
                headers: { ...corsHeaders, "Content-Type": "application/json" },
                status: 400,
            },
        );
    }
});
