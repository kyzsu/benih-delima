import * as React from 'react'

import { cn } from '@/lib/utils'

// Hand-written stand-in for shadcn's Field primitives (no CLI access in this
// environment yet — see CLAUDE.md). Mirrors the real API shape so it's a
// drop-in swap once `npx shadcn add field` can run.

function FieldGroup({ className, ...props }: React.ComponentProps<'div'>) {
  return <div className={cn('flex flex-col gap-6', className)} {...props} />
}

function Field({
  className,
  orientation = 'vertical',
  ...props
}: React.ComponentProps<'div'> & { orientation?: 'vertical' | 'horizontal' }) {
  return (
    <div
      data-orientation={orientation}
      className={cn(
        'group/field flex flex-col gap-2',
        orientation === 'horizontal' && 'flex-row items-center justify-between gap-4',
        'data-[invalid]:text-destructive',
        className,
      )}
      {...props}
    />
  )
}

function FieldLabel({ className, ...props }: React.ComponentProps<'label'>) {
  return (
    <label
      className={cn(
        'text-sm leading-none font-medium select-none group-data-[disabled]/field:opacity-50',
        className,
      )}
      {...props}
    />
  )
}

function FieldDescription({ className, ...props }: React.ComponentProps<'p'>) {
  return <p className={cn('text-sm text-muted-foreground', className)} {...props} />
}

export { Field, FieldGroup, FieldLabel, FieldDescription }
