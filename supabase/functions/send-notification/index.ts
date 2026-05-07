import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
// A simplified JWT approach or Google Auth library would be needed in Deno for FCM v1
// For this example, we assume we use a direct FCM v1 REST call or a library

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: { ...corsHeaders } });
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // Prevent JSON parse errors if visited in a browser or without a body
    if (req.method !== 'POST') {
      return new Response(JSON.stringify({ error: "Method not allowed. Use POST." }), { headers: corsHeaders, status: 405 });
    }

    let payload;
    try {
      payload = await req.json();
    } catch (e) {
      return new Response(JSON.stringify({ error: "Invalid or missing JSON body" }), { headers: corsHeaders, status: 400 });
    }

    const { record, type } = payload;

    if (type !== "INSERT" || !record) {
      return new Response("Not an insert", { headers: corsHeaders });
    }

    // This function handles the database trigger payload
    // The trigger already inserted notifications into the 'notifications' table.
    // Here we could fetch the unread notifications or the trigger can pass the notification data
    // Assuming the payload is from the `notifications` table itself

    const userId = record.user_id;
    const { data: profile } = await supabaseClient
      .from("profiles")
      .select("fcm_token")
      .eq("id", userId)
      .single();

    if (profile && profile.fcm_token) {
      const fcmToken = profile.fcm_token;
      
      // Here you would authenticate with Google Cloud using a Service Account
      // and call the FCM HTTP v1 API.
      // E.g.
      // const accessToken = await getGoogleAccessToken();
      // await fetch(`https://fcm.googleapis.com/v1/projects/${FIREBASE_PROJECT_ID}/messages:send`, {
      //   method: 'POST',
      //   headers: {
      //     'Authorization': `Bearer ${accessToken}`,
      //     'Content-Type': 'application/json',
      //   },
      //   body: JSON.stringify({
      //     message: {
      //       token: fcmToken,
      //       notification: {
      //         title: record.title,
      //         body: record.body,
      //       },
      //       data: record.data,
      //     }
      //   })
      // });
      console.log(`Sending push to ${fcmToken}: ${record.title}`);
    }

    return new Response(JSON.stringify({ success: true }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 400,
    });
  }
});
