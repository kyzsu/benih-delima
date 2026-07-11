-- Links a new Supabase Auth user (created on first magic-link login) back to
-- the pics/members row that was provisioned for them ahead of time, matched
-- by email. Rows are created by a PIC (for members) or by an admin (for pics)
-- before the person ever logs in, so auth_user_id starts NULL and gets filled
-- in here the first time that email signs in.

create function public.link_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.members
    set auth_user_id = new.id
    where email = new.email and auth_user_id is null;

  update public.pics
    set auth_user_id = new.id
    where email = new.email and auth_user_id is null;

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.link_auth_user();
