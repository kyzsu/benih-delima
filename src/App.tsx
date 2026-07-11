import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Field, FieldGroup, FieldLabel, FieldDescription } from '@/components/ui/field'

function App() {
  return (
    <div className="flex min-h-svh items-center justify-center p-6">
      <div className="w-full max-w-sm space-y-6">
        <div className="space-y-1 text-center">
          <h1 className="text-2xl font-semibold">Benih Delima</h1>
          <p className="text-sm text-muted-foreground">Scaffold check: Tailwind + UI primitives</p>
        </div>
        <FieldGroup>
          <Field>
            <FieldLabel htmlFor="email">Email</FieldLabel>
            <Input id="email" type="email" placeholder="nama@email.com" />
            <FieldDescription>Placeholder for the magic-link login screen.</FieldDescription>
          </Field>
        </FieldGroup>
        <Button className="w-full">Kirim Magic Link</Button>
      </div>
    </div>
  )
}

export default App
