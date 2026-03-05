import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import 'payment_confirmation_screen.dart';

class PaymentDataScreen extends StatefulWidget {
  const PaymentDataScreen({super.key});

  @override
  State<PaymentDataScreen> createState() => _PaymentDataScreenState();
}

class _PaymentDataScreenState extends State<PaymentDataScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _holderController = TextEditingController();
  bool _saveCard = true;
  final CartService _cart = CartService();

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFF5F6FA);
    const Color darkGray = Color(0xFF333333);
    const Color primaryBlue = Color(0xFF4A80F0);
    const Color labelGray = Color(0xFF808080);

    return ListenableBuilder(
      listenable: _cart,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Payment data",
              style: TextStyle(
                color: darkGray,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: darkGray, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  "Total price",
                  style: TextStyle(color: labelGray, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${_cart.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: primaryBlue,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),
                _buildCartItemsSection(darkGray),
                const SizedBox(height: 32),
                const Text(
                  "Payment Method",
                  style: TextStyle(
                    color: darkGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPaymentMethodPill("PayPal", false),
                      const SizedBox(width: 12),
                      _buildPaymentMethodPill("Credit", true),
                      const SizedBox(width: 12),
                      _buildPaymentMethodPill("Wallet", false),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                _buildInputLabel("Card number"),
                const SizedBox(height: 12),
                _buildCardInput(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("Valid until"),
                          const SizedBox(height: 12),
                          _buildRoundedInput(_expiryController, "Month / Year"),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputLabel("CVV"),
                          const SizedBox(height: 12),
                          _buildRoundedInput(_cvvController, "***"),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildInputLabel("Card holder"),
                const SizedBox(height: 12),
                _buildRoundedInput(_holderController, "Your name and surname"),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Save card data for future payments",
                      style: TextStyle(color: darkGray, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _saveCard,
                        onChanged: (val) => setState(() => _saveCard = val),
                        activeColor: Colors.white,
                        activeTrackColor: primaryBlue,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                _buildProceedButton(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartItemsSection(Color darkGray) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cart Items",
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        ..._cart.items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, size: 20, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text("\$${item.price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  onPressed: () {
                    _cart.removeItem(item);
                    if (_cart.items.isEmpty) {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildPaymentMethodPill(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF4A80F0) : const Color(0xFFE8ECF5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: active
            ? [
                BoxShadow(
                  color: const Color(0xFF4A80F0).withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                )
              ]
            : null,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFFA4ADBC),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
                border: active ? null : Border.all(color: const Color(0xFFA4ADBC), width: 1.5),
              ),
              child: Icon(
                Icons.check,
                color: active ? const Color(0xFF4A80F0) : const Color(0xFFA4ADBC),
                size: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInput() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png',
            height: 24,
            width: 40,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.credit_card, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: "**** **** **** 1298",
                hintStyle: TextStyle(color: Color(0xFFB0B0B0), letterSpacing: 2),
              ),
              style: const TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedInput(TextEditingController controller, String hint) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Center(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFB0B0B0), fontWeight: FontWeight.w400),
          ),
          style: const TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProceedButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A80F0), Color(0xFF6A9BFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A80F0).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaymentConfirmationScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: const Text(
          "Proceed to confirm",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
