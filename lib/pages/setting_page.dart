import 'package:flutter/material.dart';
import 'package:rhyme_app/components/appbar.dart';
import 'package:rhyme_app/components/buttons.dart';
import 'package:rhyme_app/components/glass.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool longVowelSame = true;
  bool smallTsuSame = true;
  bool nExcluded = false;
  bool dakutenApprox = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            AppHeader(
              title: '設定',
              left: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: const Icon(Icons.arrow_back, size: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Glass(
                radius: 22,
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('ゆる踏み設定', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Text('近似の許容範囲を調整', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.65))),
                  const SizedBox(height: 12),
                  _toggle('長音「ー」を同一扱い', longVowelSame, (v) => setState(() => longVowelSame = v)),
                  const SizedBox(height: 10),
                  _toggle('促音「っ」を同一扱い', smallTsuSame, (v) => setState(() => smallTsuSame = v)),
                  const SizedBox(height: 10),
                  _toggle('「ん」を母音に含めない', nExcluded, (v) => setState(() => nExcluded = v)),
                  const SizedBox(height: 10),
                  _toggle('濁音を近似OK', dakutenApprox, (v) => setState(() => dakutenApprox = v)),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Glass(
                radius: 22,
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('データ', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Text('ネタ帳をバックアップ', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.65))),
                  const SizedBox(height: 12),
                  SecondaryButton(text: 'CSVエクスポート（後で実装）', onPressed: () {}),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}