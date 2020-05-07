class NodeView: SFView {
  let view: SFView
  let shape: NodeShape

  // node
  var id: String? // change to Node
  let config: NodeConfig

  convenience init(node: Node, config: NodeConfig) {
    self.init(Label(node.title), shape: node.shape, config: config)
    self.id = node.id
  }

  init(_ view: SFView, shape: NodeShape, config: NodeConfig) {
    self.view = view
    self.shape = shape
    self.config = config
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = self.config.backgroundColor
    self.setContentHuggingPriority(.required, for: .horizontal)
    self.setContentHuggingPriority(.required, for: .vertical)
    self.addSubview(view)

    var constraints: [NSLayoutConstraint] = []
    constraints += [
      centerXAnchor.constraint(equalTo: view.centerXAnchor),
      centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ]

    switch shape {
    case .rect, .pill:
      view.layoutMargins = UIEdgeInsets(top: -5, left: -10, bottom: -5, right: -10)
      constraints += [
        topAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.topAnchor),
        leadingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
        bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),
        trailingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
      ]
    case .diamond:
      view.layoutMargins = UIEdgeInsets(top: -view.intrinsicContentSize.width/2,
                                        left: -view.intrinsicContentSize.height/2,
                                        bottom: -view.intrinsicContentSize.width/2,
                                        right: -view.intrinsicContentSize.height/2)
      constraints += [
        topAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.topAnchor),
        leadingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
        bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),
        trailingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
      ]
    }

    NSLayoutConstraint.activate(constraints)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    switch shape {
    case .rect:
      self.layer.cornerRadius = 0
      self.layer.borderWidth = 1.0
      self.layer.borderColor = SFColor.black.cgColor

    case .pill:
      self.layer.cornerRadius = self.layer.bounds.height / 2
      self.layer.borderWidth = 1.0
      self.layer.borderColor = SFColor.black.cgColor

    case .diamond:
      let maskLayer = CAShapeLayer()
      maskLayer.path = SFBezierPath.diamond(self.bounds, inset: 0).cgPath
      self.layer.mask = maskLayer

      let strokeLayer = CAShapeLayer()
      strokeLayer.lineWidth = 1.0
      strokeLayer.path = SFBezierPath.diamond(self.bounds, inset: strokeLayer.lineWidth).cgPath
      strokeLayer.strokeColor = SFColor.black.cgColor
      strokeLayer.fillColor = SFColor.clear.cgColor
      self.layer.addSublayer(strokeLayer)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  public override var description: String {
    return "[NodeView frame = \(frame), subviews = \(subviews)]"
  }

  override var intrinsicContentSize: CGSize {
    view.layoutIfNeeded()
    return CGSize(width: view.intrinsicContentSize.width - view.layoutMargins.left - view.layoutMargins.right,
                  height: view.intrinsicContentSize.height - view.layoutMargins.top - view.layoutMargins.bottom)
  }
}
