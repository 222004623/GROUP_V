alter table public.profiles
  add column date_of_birth text,
  add column gender text,
  add column address text,
  add column emergency_contact_name text,
  add column emergency_contact_phone text;

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  recipient_id uuid not null references public.profiles(id) on delete cascade,
  actor_id uuid references public.profiles(id) on delete set null,
  application_id uuid references public.applications(id) on delete cascade,
  title text not null,
  message text not null,
  type text not null,
  is_read boolean not null default false,
  created_at timestamp with time zone not null default now()
);

create index notifications_recipient_created_at_idx
  on public.notifications (recipient_id, created_at desc);

create index notifications_unread_idx
  on public.notifications (recipient_id, is_read)
  where is_read = false;

alter table public.notifications enable row level security;

create policy "Users can read own notifications"
  on public.notifications
  for select
  using (auth.uid() = recipient_id);

create policy "Users can update own notifications"
  on public.notifications
  for update
  using (auth.uid() = recipient_id)
  with check (auth.uid() = recipient_id);

create policy "Authenticated users can create notifications"
  on public.notifications
  for insert
  to authenticated
  with check (auth.uid() = actor_id or actor_id is null);
