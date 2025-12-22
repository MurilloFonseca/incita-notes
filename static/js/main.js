const changeTheme = async () => {
  await fetch('/dark-mode', { method: 'PUT' })
  location.reload()
}
