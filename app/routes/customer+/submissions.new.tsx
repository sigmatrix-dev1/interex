import { data, useLoaderData } from 'react-router'
import { type LoaderFunctionArgs } from 'react-router'
import { requireUserId } from '#app/utils/auth.server.ts'
import { prisma } from '#app/utils/db.server.ts'

export const loader = async ({ request }: LoaderFunctionArgs) => {
  const userId = await requireUserId(request)
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: { customer: true }
  })
  
  if (!user) {
    throw new Response('Unauthorized', { status: 401 })
  }

  return data({ user })
}

export default function NewSubmission() {
  const { user } = useLoaderData<typeof loader>()
  
  return (
    <div className="max-w-2xl mx-auto py-8">
      <h1 className="text-2xl font-bold mb-6">Create New Submission</h1>
      <p>This page is under construction.</p>
    </div>
  )
}
