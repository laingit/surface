defmodule ContextTest do
  use ExUnit.Case
  use Phoenix.ConnTest

  import Surface
  import ComponentTestHelper

  defmodule Outer do
    use Surface.Component

    def begin_context(props) do
      Map.put(props.context, :field, props.field)
    end

    def render(assigns) do
      ~H"""
      <div>{{ @inner_content.() }}</div>
      """
    end

    def end_context(props) do
      Map.delete(props.context, :field)
    end
  end

  defmodule Inner do
    use Surface.Component

    def render(assigns) do
      ~H"""
      <span>{{ @context.field }}</span>
      """
    end
  end

  defmodule InnerWrapper do
    use Surface.Component

    def render(assigns) do
      ~H"""
      <Inner />
      """
    end
  end

  test "pass context to child component" do
    assigns = %{}
    code =
      ~H"""
      <Outer field="My field">
        <Inner/>
      </Outer>
      """

    assert render_surface(code) =~ """
    <div>
      <span>My field</span>
    </div>
    """
  end

  test "pass context down the tree of components" do
    assigns = %{}
    code =
      ~H"""
      <Outer field="My field">
        <InnerWrapper />
      </Outer>
      """

    assert render_surface(code) =~ """
    <div>
      <span>My field</span>
    </div>
    """
  end
end
