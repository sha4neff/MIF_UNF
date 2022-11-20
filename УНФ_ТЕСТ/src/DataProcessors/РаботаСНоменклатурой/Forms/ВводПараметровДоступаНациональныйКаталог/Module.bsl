
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ПараметрыДоступаНациональныйКаталог") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПараметрыДоступаНациональныйКаталог);
	КонецЕсли;
	Параметры.Свойство("Организация", Организация);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастройкиЭлементовФормыВТестовомРежиме();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПараметрыДоступаПояснениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	БуферОбмена = 
	"<!DOCTYPE html>
	|<html>
	|</html>";
	
	ПодключитьОбработчикОжидания("СкопироватьАдресПочтыВБуферОбмена", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Закрыть(ПараметрыДоступаНациональныйКаталог());
КонецПроцедуры

&НаКлиенте
Процедура ТестовыйРежим(Команда)
	
	Если ТестовыйРежим Тогда
		СброситьСостоянияВыгрузкиНоменклатуры(Организация);
	Иначе
		СостояниеВыгрузки = СостояниеВыгрузкиВНациональныйКаталог(Организация);
		Если СостояниеВыгрузки.НаМодерации Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Нельзя переключиться на тестовый режим пока есть данные на модерации.'"));
			ВыгружатьВНациональныйКаталог = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ТестовыйРежим = НЕ ТестовыйРежим;
	НастройкиЭлементовФормыВТестовомРежиме();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПараметрыДоступаНациональныйКаталог()

	ПараметрыДоступаНациональныйКаталог = Новый Структура;
	ПараметрыДоступаНациональныйКаталог.Вставить("apikey");
	ПараметрыДоступаНациональныйКаталог.Вставить("party_id");
	ПараметрыДоступаНациональныйКаталог.Вставить("ПолучитьШтрихкоды");
	ПараметрыДоступаНациональныйКаталог.Вставить("ТестовыйРежим");
	ЗаполнитьЗначенияСвойств(ПараметрыДоступаНациональныйКаталог, ЭтотОбъект);
	
	Возврат ПараметрыДоступаНациональныйКаталог;

КонецФункции

&НаКлиенте
Процедура СкопироватьАдресПочтыВБуферОбмена() Экспорт
	
	БуферОбмена = 
	"<!DOCTYPE html>
	|<html>
	|	<body onload='copy()'>
	|		<input id='input' type='text'/>
	|		<script>
	|			function copy() {
	|				var text = 'support@national-catalog.ru';
	|				var ua = navigator.userAgent;
	|				if  (ua.search(/MSIE/) > 0 || ua.search(/Trident/) > 0) {
	|					window.clipboardData.setData('Text', text);
	|				} else {
	|					var copyText = document.getElementById('input');
	|					copyText.value = text;
	|					copyText.select();
	|					document.execCommand('copy');
	|				}
	|			}
	|		</script>
	|	</body>
	|</html>";
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЭлементовФормыВТестовомРежиме()
	Элементы.ФормаТестовыйРежим.Пометка = ТестовыйРежим;
	Элементы.ДекорацияТестовыйРежим.Видимость = ТестовыйРежим;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СброситьСостоянияВыгрузкиНоменклатуры(Знач Организация)
	ДлительныеОперации.ВыполнитьПроцедуру(, "Обработки.РаботаСНоменклатурой.СброситьСостоянияВыгрузкиНоменклатуры", Организация, Новый Массив);
КонецПроцедуры

&НаСервереБезКонтекста
Функция СостояниеВыгрузкиВНациональныйКаталог(Знач Организация)
	Возврат Обработки.РаботаСНоменклатурой.СостояниеВыгрузкиВНациональныйКаталог(Организация);
КонецФункции

#КонецОбласти