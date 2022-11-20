
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Параметры.ИмяФормыОбъектаПечати) Тогда
		ВызватьИсключение НСтр("ru='Непосредственное открытие этой формы не предусмотрено.'");
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ОбъектыОтправки) <> Тип("Массив")
		И НЕ ЗначениеЗаполнено(Параметры.ИмяМенеджераОбъекта) Тогда
		ВызватьИсключение НСтр("ru='Непосредственное открытие этой формы не предусмотрено.'");
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ОбъектыОтправки) = Тип("Массив") И Параметры.ОбъектыОтправки.Количество() = 0
		И НЕ ЗначениеЗаполнено(Параметры.ИмяМенеджераОбъекта) Тогда
		ВызватьИсключение НСтр("ru='Непосредственное открытие этой формы не предусмотрено.'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокФормы) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	РежимВыбораПечатныхФорм = Параметры.РежимВыбораПечатныхФорм;
	
	Если ТипЗнч(Параметры.ОбъектыОтправки) = Тип("Массив") Тогда
		ОбъектыОтправки = Новый ФиксированныйМассив(Параметры.ОбъектыОтправки);
	Иначе
		ОбъектыОтправки = Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИмяМенеджераОбъекта) Тогда
		ИмяМенеджераОбъекта = Параметры.ИмяМенеджераОбъекта;
	Иначе
		ИмяМенеджераОбъекта = ОбъектыОтправки[0].Метаданные().ПолноеИмя();
	КонецЕсли;
	
	Если Параметры.Свойство("ДополнительныеПараметрыПечати") Тогда
		ДополнительныеПараметрыПечати = Параметры.ДополнительныеПараметрыПечати;
	Иначе
		ДополнительныеПараметрыПечати = Неопределено;
	КонецЕсли;
	
	ПрочитатьКомандыПечати();
	ПрочитатьНастройкиФормы();
	
	Если ЭтоОтправкаПечатныхФормДоговора() Тогда
		Элементы.ПредставлениеФорматаВложений.Видимость = Ложь;
	Иначе
		ПредставлениеФорматаВложений = ПолучитьПредставлениеФорматаВложений(ВыбранныеФорматыСохранения, УпаковатьВАрхив);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РежимВыбораПечатныхФорм Тогда
		СохранитьНастройкиФормы(КлючНастроек, ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(ПечатныеФормы));
	Иначе
		// Сохранение печатных форм происходит по команде Выбрать.
	КонецЕсли;
	
	Оповестить("ВыборПечатныхФормДляОтправки");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборФорматаВложений") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			
			УпаковатьВАрхив = ВыбранноеЗначение.УпаковатьВАрхив;
			ПереводитьИменаФайловВТранслит = ВыбранноеЗначение.ПереводитьИменаФайловВТранслит;
			ВыбранныеФорматыСохранения.ЗаполнитьПометки(Ложь);
			
			Для Каждого ВыбранныйФормат Из ВыбранноеЗначение.ФорматыСохранения Цикл
				ФорматНаФорме = ВыбранныеФорматыСохранения.НайтиПоЗначению(ВыбранныйФормат);
				Если ФорматНаФорме <> Неопределено Тогда
					ФорматНаФорме.Пометка = Истина;
				КонецЕсли;
			КонецЦикла;
			
			ПредставлениеФорматаВложений = ПолучитьПредставлениеФорматаВложений(ВыбранныеФорматыСохранения, УпаковатьВАрхив);
			
		КонецЕсли;
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ПодготовкаНовогоПисьма") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			
			ПараметрыОтправки.Получатель.Очистить();
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПараметрыОтправки.Получатель, ВыбранноеЗначение.Получатели);
			СоздатьНовоеПисьмо();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПредставлениеФорматаВложенийНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранныеФорматыВСтроках = Новый Массив;
	Для каждого Формат Из ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(ВыбранныеФорматыСохранения) Цикл
		ВыбранныеФорматыВСтроках.Добавить(Строка(Формат));
	КонецЦикла;
	
	НастройкиФормата = Новый Структура;
	НастройкиФормата.Вставить("УпаковатьВАрхив", УпаковатьВАрхив);
	НастройкиФормата.Вставить("ФорматыСохранения", ВыбранныеФорматыВСтроках);
	НастройкиФормата.Вставить("ПереводитьИменаФайловВТранслит", ПереводитьИменаФайловВТранслит);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("НастройкиФормата", НастройкиФормата);
	ОткрытьФорму("ОбщаяФорма.ВыборФорматаВложений", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если РежимВыбораПечатныхФорм Тогда
		СохранитьНастройкиФормы(КлючНастроек, ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(ПечатныеФормы));
		Закрыть();
		Возврат;
	КонецЕсли;
	
	СформироватьВложенияИВыбратьПолучателей();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьКомандыПечати()
	
	ПоказыватьКомандыПечатиПоШаблонамПечати = Истина;
	Если Параметры.Свойство("ПоказыватьКомандыПечатиПоШаблонамПечатиОфисныхДокументов") Тогда
		ПоказыватьКомандыПечатиПоШаблонамПечати = Параметры.ПоказыватьКомандыПечатиПоШаблонамПечатиОфисныхДокументов;
	КонецЕсли;
	
	КомандыПечати = УправлениеПечатью.КомандыПечатиФормы(Параметры.ИмяФормыОбъектаПечати);
	Для Каждого КомандаПечати Из КомандыПечати Цикл
		
		Если КомандаПечати.СкрытаФункциональнымиОпциями
			И НЕ УправлениеНебольшойФирмойСервер.ОтображатьКомандуПриВыключеннойФО(КомандаПечати) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ УправлениеНебольшойФирмойСервер.КомандаПечатаетсяВСерверномКонтексте(КомандаПечати) Тогда
			Продолжить;
		КонецЕсли;
		
		Если КомандаПечати.ДополнительныеПараметры.Свойство("ВариантЗапуска") Тогда
			Если КомандаПечати.ДополнительныеПараметры.ВариантЗапуска <> Перечисления.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода
				Или Не ЗначениеЗаполнено(КомандаПечати.ДополнительныеПараметры.Ссылка) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ПоказыватьКомандыПечатиПоШаблонамПечати
			И ТипЗнч(КомандаПечати.ДополнительныеПараметры) = Тип("Структура")
			И КомандаПечати.ДополнительныеПараметры.Свойство("НазначениеШаблона") Тогда
			Продолжить;
		КонецЕсли;
		
		ПечатныеФормы.Добавить(КомандаПечати.Идентификатор, КомандаПечати.Представление);
		
	КонецЦикла;
	АдресКомандПечати = ПоместитьВоВременноеХранилище(КомандыПечати, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиФормы()
	
	КлючНастроек = ?(ЗначениеЗаполнено(Параметры.КлючНастроек), Параметры.КлючНастроек, ИмяМенеджераОбъекта);
	
	НастройкаПечатныхФорм = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОтправкаПечатныхФорм", КлючНастроек);
	Если НастройкаПечатныхФорм <> Неопределено Тогда
		Для Каждого ВыбраннаяПечатнаяФорма Из НастройкаПечатныхФорм Цикл 
			Команда = ПечатныеФормы.НайтиПоЗначению(ВыбраннаяПечатнаяФорма);
			Если Команда <> Неопределено Тогда
				Команда.Пометка = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НастройкиСохранения = НастройкиСохраненияПечатныхФормПользователя();
	УпаковатьВАрхив = НастройкиСохранения.УпаковатьВАрхив;
	ПереводитьИменаФайловВТранслит = НастройкиСохранения.ПереводитьИменаФайловВТранслит;
	
	ДоступныеФорматы = СтандартныеПодсистемыСервер.НастройкиФорматовСохраненияТабличногоДокумента();
	Для каждого ФорматСохранения Из ДоступныеФорматы Цикл
		
		// Для возможности использования в мобильном клиенте.
		ФорматСохраненияПредставление = Строка(ФорматСохранения.Ссылка);
		ФорматСохраненияСтрокой = Строка(ФорматСохранения.ТипФайлаТабличногоДокумента);
		
		ЭтотФорматСохраненВНастройках = НастройкиСохранения.ФорматыСохранения.Найти(ФорматСохраненияСтрокой) <> Неопределено;
		ВыбранныеФорматыСохранения.Добавить(
			ФорматСохраненияСтрокой,
			ФорматСохраненияПредставление,
			ЭтотФорматСохраненВНастройках,
			ФорматСохранения.Картинка);
	КонецЦикла;
	
	НеВыбранаНиОднаПечатнаяФорма = ПечатныеФормы.Количество() > 0
		И ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(ПечатныеФормы).Количество() = 0;
	Если НеВыбранаНиОднаПечатнаяФорма Тогда
		ПечатныеФормы[0].Пометка = Истина;
	КонецЕсли;
	
	НеВыбранНиОдинФормат = ВыбранныеФорматыСохранения.Количество() > 0
		И ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(ВыбранныеФорматыСохранения).Количество() = 0;
	Если НеВыбранНиОдинФормат Тогда
		ВыбранныеФорматыСохранения[0].Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НастройкиСохраненияПечатныхФормПользователя()
	
	НастройкиСохраненияПечатныхФорм = УправлениеПечатью.НастройкиСохранения();
	
	СохраненныеНастройкиФормата = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(
		"ОбщаяФорма.ВыборФорматаВложений/ТекущиеДанные", "");
	
	Если СохраненныеНастройкиФормата = Неопределено Тогда
		Возврат НастройкиСохраненияПечатныхФорм;
	КонецЕсли;
	
	СохраненныеФорматы         = СохраненныеНастройкиФормата.Получить("ВыбранныеФорматыСохранения");
	СохраненныйУпаковатьВАрхив = СохраненныеНастройкиФормата.Получить("УпаковатьВАрхив");
	СохраненныйПереводитьИменаФайловВТранслит = СохраненныеНастройкиФормата.Получить("ПереводитьИменаФайловВТранслит");
	
	Если СохраненныеФорматы <> Неопределено Тогда
		НастройкиСохраненияПечатныхФорм.ФорматыСохранения = ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(СохраненныеФорматы);
	КонецЕсли;
	
	Если СохраненныйУпаковатьВАрхив <> Неопределено Тогда
		НастройкиСохраненияПечатныхФорм.УпаковатьВАрхив = СохраненныйУпаковатьВАрхив;
	КонецЕсли;
	
	Если СохраненныйПереводитьИменаФайловВТранслит <> Неопределено Тогда
		НастройкиСохраненияПечатныхФорм.ПереводитьИменаФайловВТранслит = СохраненныйПереводитьИменаФайловВТранслит;
	КонецЕсли;
	
	Возврат НастройкиСохраненияПечатныхФорм;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройкиФормы(КлючНастроек, ВыбранныеКоманды)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОтправкаПечатныхФорм", КлючНастроек, ВыбранныеКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьВложенияИВыбратьПолучателей()
	
	ВыбранныеКоманды = ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(ПечатныеФормы);
	
	СформироватьВложенияИВыбратьПолучателейСервер(ВыбранныеКоманды);
	
	Если ПараметрыОтправки.Получатель.Количество() > 1 Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Получатели", ПараметрыОтправки.Получатель);
		ПараметрыФормы.Вставить("НеВыбиратьФорматВложений", Истина);
		ОткрытьФорму("ОбщаяФорма.ПодготовкаНовогоПисьма", ПараметрыФормы, ЭтотОбъект);
	Иначе
		СоздатьНовоеПисьмо();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьВложенияИВыбратьПолучателейСервер(ВыбранныеКоманды)
	
	МассивОбъектов = ОбщегоНазначения.СкопироватьРекурсивно(ОбъектыОтправки);
	
	ЗаполнитьВложенияПисьма(МассивОбъектов, ВыбранныеКоманды);
	ЗаполнитьПолучателейПисьма(МассивОбъектов, ВыбранныеКоманды);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВложенияПисьма(МассивОбъектов, ВыбранныеКоманды)
	
	Если ВыбранныеКоманды.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиСохранения = УправлениеПечатью.НастройкиСохранения();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НастройкиСохранения.ФорматыСохранения, ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(ВыбранныеФорматыСохранения));
	НастройкиСохранения.ПереводитьИменаФайловВТранслит = ПереводитьИменаФайловВТранслит;
	НастройкиСохранения.УпаковатьВАрхив = УпаковатьВАрхив;
	
	СформированныеФайлы = УправлениеПечатью.НапечататьВФайл(ВыбранныеКомандыПечати(ВыбранныеКоманды), МассивОбъектов, НастройкиСохранения);
	СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
	
	Вложения.Очистить();
	Для каждого СформированныйФайл Из СФормированныеФайлы Цикл
		Вложения.Добавить(ПоместитьВоВременноеХранилище(СформированныйФайл.ДвоичныеДанные, УникальныйИдентификатор), СформированныйФайл.ИмяФайла);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПолучателейПисьма(МассивОбъектов, ВыбранныеКоманды)
	
	ПараметрыОтправкиПФ = Новый Структура("Получатель,Тема,Текст", Неопределено, "", "");
	
	Если ВыбранныеКоманды.Количество() <> 0 Тогда
		УправлениеНебольшойФирмойСервер.ЗаполнитьПараметрыОтправки(ПараметрыОтправкиПФ, МассивОбъектов);
	Иначе
		ПараметрыОтправкиПФ.Получатель = УправлениеНебольшойФирмойСервер.ПолучитьПодготовленныеЭлектронныеАдресаПолучателей(МассивОбъектов);
	КонецЕсли;
	
	ЗаполнитьПараметрыОтправки(ПараметрыОтправкиПФ);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыОтправки(ПараметрыОтправкиПФ)
	
	Если ПараметрыОтправки = Неопределено Тогда
		ПараметрыОтправкиВрем = Новый Структура;
		ПараметрыОтправкиВрем.Вставить("Отправитель");
		ПараметрыОтправкиВрем.Вставить("Текст");
		ПараметрыОтправкиВрем.Вставить("Тема");
		ПараметрыОтправкиВрем.Вставить("Получатель", Новый Массив);
	Иначе
		ПараметрыОтправкиВрем = ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыОтправки, Ложь);
	КонецЕсли;
	
	Если ПараметрыОтправкиПФ.Свойство("Получатель") Тогда
		ДополнитьМассив(ПараметрыОтправкиВрем.Получатель, ПараметрыОтправкиПФ.Получатель);
	КонецЕсли;
	
	ПараметрыОтправкиВрем.Тема = ?(ЗначениеЗаполнено(ПараметрыОтправкиВрем.Тема), НСтр("ru='Документы'"), ПараметрыОтправкиПФ.Тема);
	
	Если ПараметрыОтправкиПФ.Свойство("Отправитель") Тогда
		ПараметрыОтправкиВрем.Отправитель = ПараметрыОтправкиПФ.Отправитель;
	КонецЕсли;
	
	ПараметрыОтправки = Новый ФиксированнаяСтруктура(ПараметрыОтправкиВрем);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПредставлениеФорматаВложений(ВыбранныеФорматыСохранения, УпаковатьВАрхив)
	
	ФорматВложений = "";
	
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			Если Не ПустаяСтрока(ФорматВложений) Тогда
				ФорматВложений = ФорматВложений + ", ";
			КонецЕсли;
			ФорматВложений = ФорматВложений + ВыбранныйФормат.Представление;
		КонецЕсли;
	КонецЦикла;
	
	Если ПустаяСтрока(ФорматВложений) Тогда
		ФорматВложений = НСтр("ru='<Не выбран формат вложений>'");
	КонецЕсли;
	
	Если УпаковатьВАрхив Тогда
		ФорматВложений = НСтр("ru='Архив .zip:'") + " " + ФорматВложений;
	КонецЕсли;
	
	Возврат ФорматВложений;
	
КонецФункции

&НаКлиенте
Процедура СоздатьНовоеПисьмо()
	
	ОбработчикРезультата = Новый ОписаниеОповещения("СоздатьНовоеПисьмоПродолжение", ЭтотОбъект);
	РаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОбработчикРезультата);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовоеПисьмоПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыНовогоПисьма = Новый Структура;
	ПараметрыНовогоПисьма.Вставить("Получатель", ПараметрыОтправки.Получатель);
	ПараметрыНовогоПисьма.Вставить("Тема", ПараметрыОтправки.Тема);
	ПараметрыНовогоПисьма.Вставить("Текст", ПараметрыОтправки.Текст);
	ПараметрыНовогоПисьма.Вставить("Вложения", ОписаниеВложенийМассивом());
	ПараметрыНовогоПисьма.Вставить("ДокументыОснования", ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ОбъектыОтправки));
	
	РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыНовогоПисьма);
	Закрыть();
	
	Если СообщенияПользователю <> Неопределено И СообщенияПользователю.Количество() > 0 Тогда
		Для каждого СообщениеПользователю Из СообщенияПользователю Цикл
			ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеПользователю.Текст,
				СообщениеПользователю.КлючДанных, СообщениеПользователю.Поле, СообщениеПользователю.ПутьКДанным);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОписаниеВложенийМассивом()
	
	Результат = Новый Массив;
	
	Для каждого Вложение Из Вложения Цикл
		
		ОписаниеВложения = Новый Структура;
		ОписаниеВложения.Вставить("Представление", Вложение.Представление);
		ОписаниеВложения.Вставить("АдресВоВременномХранилище", Вложение.Значение);
		
		Результат.Добавить(ОписаниеВложения);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Процедура дополняет массив приемник неуникальными значениями из массива источника.
// Для элементов-структур проверка осуществляется по совпадению ключей и значений структуры
//
&НаСервереБезКонтекста
Процедура ДополнитьМассив(МассивПриемник, МассивИсточник)
	
	Если ТипЗнч(МассивИсточник) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЗначениеИсточника Из МассивИсточник Цикл
		Если ТипЗнч(ЗначениеИсточника) = Тип("Структура") Тогда
			Найдено = Ложь;
			Для Каждого ЗначениеПриемника Из МассивПриемник Цикл
				Если ТипЗнч(ЗначениеПриемника) = Тип("Структура") Тогда
					ВсеКлючиСовпадают = Истина;
					Для Каждого КлючИЗначение Из ЗначениеИсточника Цикл
						Если Не (ЗначениеПриемника.Свойство(КлючИЗначение.Ключ) И ЗначениеПриемника[КлючИЗначение.Ключ] = КлючИЗначение.Значение) Тогда
							ВсеКлючиСовпадают = Ложь;
							Прервать;
						КонецЕсли;
					КонецЦикла;
					Если ВсеКлючиСовпадают Тогда
						Найдено = Истина;
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Не Найдено Тогда
				МассивПриемник.Добавить(ЗначениеИсточника);
			КонецЕсли;
		ИначеЕсли МассивПриемник.Найти(ЗначениеИсточника) = Неопределено Тогда
			МассивПриемник.Добавить(ЗначениеИсточника);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Отправка печатных форм договора будет осуществляться только из формы элемента/списка договора,
// значит других печатных форм нет.
//
&НаСервере
Функция ЭтоОтправкаПечатныхФормДоговора()
	
	Для каждого Эл Из ПечатныеФормы Цикл
		
		Если СтрНачинаетсяС(Эл.Значение, "ДоговорКонтрагента") Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция ВыбранныеКомандыПечати(ИдентификаторыКоманд)
	
	ВыбранныеКомандыПечати = Новый Массив;
	КомандыПечати = ПолучитьИзВременногоХранилища(АдресКомандПечати);
	Для каждого ИдентификаторКоманды Из ИдентификаторыКоманд Цикл
		КомандаПечати = КомандыПечати.Найти(ИдентификаторКоманды, "Идентификатор");
		Если КомандаПечати <> Неопределено Тогда
			ВыбранныеКомандыПечати.Добавить(КомандаПечати);
		КонецЕсли;
	КонецЦикла;
	Возврат ВыбранныеКомандыПечати;
	
КонецФункции

#КонецОбласти
